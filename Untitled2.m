% Write .cntk test format
clc,clear all,close all
load('TestBabaiName.mat');

fid=fopen('a.txt','w');
for i=1:length(TestBabaiName)
    fprintf(fid,'O_%s:',num2str(TestBabaiName(i)));
end

for i=1:length(TestBabaiName)
    fprintf(fid,'\n#------------------------------------\n');
    fprintf(fid,'O_%s={\n',num2str(TestBabaiName(i)));
    fprintf(fid,'    action = "write"\n');
    fprintf(fid,'	traceLevel=2\n');
    fprintf(fid,'	 reader = [\n');
    fprintf(fid,'        readerType = "CNTKTextFormatReader"\n');
    fprintf(fid,'        file = TestFilesInCntkFormat\\Test_%s_Context7.txt\n',num2str(TestBabaiName(i)));
    fprintf(fid,'        input = [\n');
    fprintf(fid,'            features = [\n');
    fprintf(fid,'             dim = 270\n');
    fprintf(fid,'                format = "dense"\n');
    fprintf(fid,'            ]\n');
    fprintf(fid,'            labels = [\n');
    fprintf(fid,'                dim = 103\n');
    fprintf(fid,'                format = "dense"\n');
    fprintf(fid,'            ]\n');
    fprintf(fid,'        ]\n');
    fprintf(fid,'    ]\n');
    fprintf(fid,'	modelPath=temp\\LandmarkNN.dnn\n');
    fprintf(fid,'	outputNodeNames=HLast\n');
    fprintf(fid,'    outputPath =tempTest\\Net_%s.txt\n',num2str(TestBabaiName(i)));
    fprintf(fid,'}\n');
    fprintf(fid,'#------------------------------------\n');
end
fclose (fid)
