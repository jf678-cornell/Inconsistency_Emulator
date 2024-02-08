function output = getNow()
output = string(datetime('now','Format','(yyyy-MM-dd''_''HH;mm*)'));
output = strrep(output,';','h');
output = strrep(output,'*','m');
end