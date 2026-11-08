set @out_badge = '0';
call gdb0041.get_market_batch(' ', 2020, @out_badge);
select @out_badge;
