--
-- Licensed to the Apache Software Foundation (ASF) under one or more
-- contributor license agreements.  See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- The ASF licenses this file to You under the Apache License, Version 2.0
-- (the "License"); you may not use this file except in compliance with
-- the License.  You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- q62 --
select
     substr(w_warehouse_name, 1, 20),
     sm_type,
     web_name,
     sum(
          case
               when (ws_ship_date_sk - ws_sold_date_sk <= 30) then 1
               else 0
          end
     ) as `30 days`,
     sum(
          case
               when (ws_ship_date_sk - ws_sold_date_sk > 30)
               and (ws_ship_date_sk - ws_sold_date_sk <= 60) then 1
               else 0
          end
     ) as `31-60 days`,
     sum(
          case
               when (ws_ship_date_sk - ws_sold_date_sk > 60)
               and (ws_ship_date_sk - ws_sold_date_sk <= 90) then 1
               else 0
          end
     ) as `61-90 days`,
     sum(
          case
               when (ws_ship_date_sk - ws_sold_date_sk > 90)
               and (ws_ship_date_sk - ws_sold_date_sk <= 120) then 1
               else 0
          end
     ) as `91-120 days`,
     sum(
          case
               when (ws_ship_date_sk - ws_sold_date_sk > 120) then 1
               else 0
          end
     ) as `>120 days`
from
     web_sales,
     warehouse,
     ship_mode,
     web_site,
     date_dim
where
     d_month_seq between 1212
     and 1212 + 11
     and ws_ship_date_sk = d_date_sk
     and ws_warehouse_sk = w_warehouse_sk
     and ws_ship_mode_sk = sm_ship_mode_sk
     and ws_web_site_sk = web_site_sk
group by
     substr(w_warehouse_name, 1, 20),
     sm_type,
     web_name
order by
     substr(w_warehouse_name, 1, 20),
     sm_type,
     web_name
limit
     100;
