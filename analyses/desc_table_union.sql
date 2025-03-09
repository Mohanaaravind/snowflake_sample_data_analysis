{% set desc %}
    DESC TABLE snowflake_sample_data.tpcds_sf100tcl.INVENTORY
{% endset %}

{% do run_query(desc) %}


{% set create_temp %}
    create or replace table snowflake_sample_cloned.public.temp
    as
    select 'inventory'::varchar(30) as table_name,* from table(result_scan(last_query_id()))
{% endset %}

{% do run_query(create_temp) %}


{% set truncate_temp %}
    truncate table if exists snowflake_sample_cloned.public.temp
{% endset %}

{% do run_query(truncate_temp) %}

select
    'temp table creation success'

{% set relations = dbt_utils.get_relations_by_prefix(
    schema="tpcds_sf100tcl", prefix="", database="snowflake_sample_data"
) %}

{% for relation in relations %}
    {% set desc_table %}
        desc table {{ relation }}
    {% endset %}

    {% do run_query(desc_table) %}

    {% set insert_temp %}
        insert into snowflake_sample_cloned.public.temp
        select '{{ relation.identifier }}' as table_name,* 
        from table(result_scan(last_query_id()))
    {% endset %}
    {% do run_query(insert_temp) %}
{%- endfor %}

union
select 'temp_table_insert_success'

union
select concat(count(*), ' rows inserted') from snowflake_sample_cloned.public.temp

union
select concat(count(distinct table_name), ' table details inserted') from snowflake_sample_cloned.public.temp
