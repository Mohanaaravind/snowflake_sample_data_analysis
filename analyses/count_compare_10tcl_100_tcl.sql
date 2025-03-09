with tcl100 as
(
    select * from {{ ref('table_record_count_100tcl') }}
),

tcl10 as
(
    select * from {{ ref('table_record_count_10tcl') }}
)

-- tcp10_size as (

-- select 
--     table_name,
--     ACTIVE_BYTES / 1024 / 1024 as active_size_gb,
--     (ACTIVE_BYTES + TIME_TRAVEL_BYTES + FAILSAFE_BYTES + RETAINED_FOR_CLONE_BYTES) / 1024 / 1024 as TOTAL_SIZE_GB
-- from
--     snowflake_sample_data.information_schema.TABLE_STORAGE_METRICS
-- where
--     table_schema = 'TPCDS_SF10TCL')

select 
        tcl100.table_name,
        trim(to_char(tcl100.c,'999,999,999,999')) as count_100tcl,
        trim(to_char(tcl10.c,'999,999,999,999')) as count_10tcl,
        round((tcl100.c/tcl10.c),2) as ratio_100_by_10
from 
    tcl100
join
    tcl10
on tcl100.table_name = tcl10.table_name
order by ratio_100_by_10 desc