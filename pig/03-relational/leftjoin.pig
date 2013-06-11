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


-- NYSE  CLNY    2009-10-30  19.33   19.49   19.33   19.45   34200   19.38
daily = load 'NYSE_daily' as (exchange, symbol, date, open, high, low, close,
            volume, adj_close);

-- NYSE  CLNY    2009-12-29  0.07
divs  = load 'NYSE_dividends' as (exchange, symbol, date, dividends);
jnd   = join daily by (symbol, date) left outer, divs by (symbol, date);

-- (NYSE,CLNY,2009-12-31,20.51,20.53,20.34,20.37,51900,20.37,,,,)
dump jnd;
