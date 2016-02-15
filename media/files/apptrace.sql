set mapred.job.queue.name =trends-data;
set mapred.job.priority=VERY_HIGH;
set mapred.map.tasks=1000;
set mapred.map.capacity=1000;



(
	select
	event_cuid,
	event_country,
	event_province,
	event_city, 
	collect_set(appinfo) apptrace
	from
	(
		select
		event_cuid,
		event_country,
		event_province,
		event_city, 
		concat(apppkg,'|',issysapp,'|',start_date,'|',end_date) appinfo
		from
		(
			select
			event_country,
			event_province,
			event_city,
			event_cuid,
			apppkg,
			issysapp, 
			start_date,
			max(end_date) as  end_date
			from
			(
				select
				event_country,
				event_province,
				event_city,
				event_cuid,
				apppkg,
				issysapp, 
				split(startend,'@')[0] start_date,
				split(startend,'@')[1] end_date
				from
				(
					select
						event_country,
						event_province,
						event_city,
						event_cuid,
						apppkg,
						apptrace['tracedata'] tracedata,
						apptrace['issysapp'] issysapp
					from
					(
						select
						event_country,
						event_province,
						event_city,
						event_cuid,
						apppkg,
						apptrace
						from
						(
							select
							event_country,
							event_province,
							event_city,
							event_cuid,
							xcloud_apptrace
							from
							udwetl_xcloud 
							where event_day=20150426   and event_hour=10   and xcloud_apptrace is not null  
						) t
						LATERAL VIEW explode(xcloud_apptrace) t_app AS  apppkg,apptrace 
					) t1
					where array_contains(map_keys(apptrace),'tracedata')
				) t2
				LATERAL VIEW explode(split(substr(tracedata,1,length(tracedata)-1),',')) t_time AS  startend 
			) t3
			group by
			event_country,
			event_province,
			event_city,
			event_cuid,
			apppkg,
			issysapp, 
			start_date
		) t4
	) t5
	group by event_cuid,
	event_country,
	event_province,
	event_city
) t_trace
outer full join
(
	select
	event_cuid,
	event_country,
	event_province,
	event_city, 
	eventpower
	from
	udwetl_xcloud 
	LATERAL VIEW explode(xcloud_operationeventpower) t_power AS eventpower
	where event_day=20150426   and event_hour=10   and xcloud_operationeventpower is not null and size(xcloud_operationeventpower)>=1
)