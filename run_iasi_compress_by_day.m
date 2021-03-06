function run_iasi_compress_by_day()
addpath(genpath('~/git/rtp_prod2'));
addpath('~/git/iasi_pcc');

% grab the slurm array index for this process
slurmindex = str2num(getenv('SLURM_ARRAY_TASK_ID'));

% File ~/git/iasi_pcc/iasi_file_list is a list of filepaths to the
% directories where the input files or this processing are to be found. For the
% initial runs, this was generated by a call to 'ls' while sitting in
% the directory /asl/data/IASI/L1C:
% ls -d1 $PWD/20??/*/* >> ~/git/iasi_pcc/iasi_file_list
%
% there are a few *.txt files that get picked up and have to edited
% out by hand
%
% iasi_file_list, then, contains lines like:
%    /asl/data/IASI/L1C/2007/06/02
[status, indir] = system(sprintf('sed -n "%dp" %s | tr -d "\n"', ...
                                  slurmindex, '~/git/iasi_pcc/iasi_file_list'));

% call the processing function
iasi_pcc_compress_day(indir)

end