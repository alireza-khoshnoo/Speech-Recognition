% data augmentation
% استفاده از تابع
wordList = {'bale', 'na', 'salam','bala','basteh','baz','bebakhshid','boro','chap','khamoosh','khodahafez','komak','lotfan','payan','paeen','rast','roshan','shoro','tashakkor','tavaghof'};
numAugmentations = 10;
disp('please wait ...');
for i= 1: size(wordList, 2)
  currentWord = wordList{i}; 
  disp(currentWord);
  for j= 1: 5
    inputFilePath = strcat('data\', currentWord, '\', currentWord, '_0' , num2str(j), '.wav');
    outputDirectory = strcat('data\', currentWord);
    augmentedFiles = augmentAudio(inputFilePath, numAugmentations, outputDirectory);
  end
end

disp('Augmented files were created successfully');
outputDir = outputDirectory;
function augmentedAudioFiles = augmentAudio(filePath, numAugmentations, outputDir)
    % خواندن فایل صوتی اصلی
    [audioData, fs] = audioread(filePath);
    
    % ایجاد دایرکتوری خروجی در صورت عدم وجود
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    % لیست از توابع افزایش داده‌ها
    augmentationFunctions = {@changeSpeed, @addNoise, @shiftTime};
    
    augmentedAudioFiles = cell(numAugmentations, 1);
    
    for i = 1:numAugmentations
        % انتخاب تصادفی یک تابع افزایش داده‌ها
        funcIndex = mod(i,3)+1;
        augmentedAudio = augmentationFunctions{funcIndex}(audioData, fs);
        
        % ذخیره فایل صوتی جدید
        [~, name, ext] = fileparts(filePath);
        newFileName = fullfile(outputDir, [name, '_augmented_', num2str(i), ext]);
        audiowrite(newFileName, augmentedAudio, fs);
        augmentedAudioFiles{i} = newFileName;
    end
end

% توابع افزایش داده‌ها

function augmentedAudio = changeSpeed(audioData, fs)
    % تغییر سرعت پخش (با ضریب بین 0.8 تا 1.2)
    speedFactor = 0.8 + (1.2-0.8).*rand(1,1);
    augmentedAudio = resample(audioData, round(fs*speedFactor), fs);
end


function augmentedAudio = addNoise(audioData, fs)
    % افزودن نویز سفید با سطح بین 0.001 تا 0.005
    noiseLevel = 0.001 + (0.005-0.001).*rand(1,1);
    noise = noiseLevel * randn(size(audioData));
    augmentedAudio = audioData + noise;
end

function augmentedAudio = shiftTime(audioData, fs)
    % جابجایی زمانی (با حداکثر جابجایی 0.1 ثانیه)
    shiftTime = -0.1 + (0.1-(-0.1)).*rand(1,1);
    shiftSamples = round(shiftTime * fs);
    augmentedAudio = circshift(audioData, shiftSamples);
end

