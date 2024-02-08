function array = readAndSubtract(var1,scaling1,var2,scaling2,run,suffix,years,ensemble_number)
array = readFromGAUSS(var1,scaling1,run,suffix,years,ensemble_number)-readFromGAUSS(var2,scaling2,run,suffix,years,ensemble_number);
end