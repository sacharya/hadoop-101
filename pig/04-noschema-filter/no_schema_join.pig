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

-- NYSE  CLNY    2009-12-29  0.07
divs  = load 'NYSE_dividends' as (exchange, stock_symbol, date, dividends);

-- NYSE  CLNY    2009-10-30  19.33   19.49   19.33   19.45   34200   19.38
daily = load 'NYSE_daily';

jnd   = join divs by stock_symbol, daily by $1;

-- (NYSE,CLNY,2009-12-29,0.07,NYSE,CLNY,2009-10-30,19.33,19.49,19.33,19.45,34200,19.38)
dump jnd;
