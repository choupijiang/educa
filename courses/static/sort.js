/**
 * Created by zhangshenghu on 2016/2/15.
 */
$('#module').sortable({
        stop: function(event, ui){
            modules_order = {};
            $('#modules').children().each(function(){
                // update the order field
                $(this).find('.order').text($(this).index() + 1);
                // associate the module's id with its order
                modules_order[$(this).data('id')] = $(this).index();
            });
            $.ajax({
                type: 'POST',
                url : '{% url "module_order" %}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: Json.stringify(modules_order)
            })
        }
    }
)