-- This code is made available under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
-- WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
-- License for the specific language governing permissions and limitations
-- under the License.

-- NYSE CMP 2009-09-17  59.06   59.95   57.86   58.17   704000  57.86
daily = load 'NYSE_daily' as (exchange, stock);
grpd  = group daily all;
cnt   = foreach grpd generate COUNT(daily);

(57391)
dump cnt;

