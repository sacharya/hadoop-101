dividends = load 'NYSE_dividends' as (exchange, symbol, date, dividend);
grouped   = group dividends by symbol;
avg       = foreach grouped generate group, AVG(dividends.dividend);
store avg into 'average_dividend';
