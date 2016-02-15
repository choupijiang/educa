# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('courses', '0003_auto_20160213_2144'),
    ]

    operations = [
        migrations.AddField(
            model_name='content',
            name='module',
            field=models.ForeignKey(related_name='contents', default=0, to='courses.Module'),
            preserve_default=False,
        ),
    ]
