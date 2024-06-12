clc
clear 
close all

% پارامترهای ضبط
fs = 16000; % نرخ نمونه‌برداری (هرتز)
nBits = 16; % تعداد بیت‌ها در هر نمونه
nChannels = 1; % تعداد کانال‌ها (1 برای مونو)

% تعداد کلمات و تعداد تکرارها
wordList = {'bale', 'na', 'salam','bala','basteh','baz','bebakhshid','boro','chap','khamoosh','khodahafez','komak','lotfan','payan','paeen','rast','roshan','shoro','tashakkor','tavaghof'};
numWords = size(wordList, 2);
numRepetitions = 5;

% ایجاد پوشه‌ها
dataset = 'data';
if ~exist(dataset, 'dir')
    mkdir(dataset);
end

for i = 1:numWords
    wordDir = fullfile(dataset, wordList{i});
    if ~exist(wordDir, 'dir')
        mkdir(wordDir);
    end
end

% ضبط صدا
recObj = audiorecorder(fs, nBits, nChannels);
for i = 1:numWords
    for j = 1:numRepetitions
        
        disp(['Please say ', wordList{i}, ' ', num2str(j)]);
        pause(1); % یک ثانیه مکث برای آمادگی
        recordblocking(recObj, 2); % ضبط برای 2 ثانیه
        disp('Recording finished.');
        audioData = getaudiodata(recObj);
        filename = fullfile(dataset, wordList{i}, [wordList{i}, '_', num2str(j, '%02d'), '.wav']);
        audiowrite(filename, audioData, fs);
    end
end