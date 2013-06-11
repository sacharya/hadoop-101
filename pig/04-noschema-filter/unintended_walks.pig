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

/* Jorge Posada  New York Yankees    {(Catcher),(Designated_hitter)} [games#1594,hit_by_pitch#65,on_base_percentage#0.379,grand_slams#7,home_runs#243,at_bats#5365,sacrifice_flies#43,gdb#163,sacrifice_hits#1,ibbs#71,base_on_balls#838,hits#1488,rbis#964,slugging_percentage#0.48,batting_average#0.277,triples#9,doubles#342,strikeouts#1278,runs#817]
*?

player     = load 'baseball' as (name:chararray, team:chararray,
               pos:bag{t:(p:chararray)}, bat:map[]);
unintended = foreach player generate bat#'base_on_balls' - bat#'ibbs';

-- (227.0)
dump unintended;
