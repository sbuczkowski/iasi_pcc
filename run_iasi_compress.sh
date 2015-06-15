#!/bin/bash
#
# usage: 
#
# 

# sbatch options
#SBATCH --job-name=RUN_CREATE_IASI_COMPRESS
# partition = dev/batch
#SBATCH --partition=batch
# qos = short/normal/medium/long/long_contrib
#SBATCH --qos=short
#SBATCH --account=pi_strow
#SBATCH -N1
#SBATCH --mem-per-cpu=18000
#SBATCH --cpus-per-task 1
###SBATCH --array=1-540
#SBATCH --time=00:40:00

# matlab options
MATLAB=/usr/cluster/matlab/current/bin/matlab
MATOPT=' -nojvm -nodisplay -nosplash'


#LOGDIR=~/logs/sbatch
#DT=$(date +"%Y%m%d-%H%M%S")

JOBSTEP=0

echo "Executing srun of run_iasi_compress"
srun $MATLAB $MATOPT -r "addpath(genpath('~/git/rtp_prod2')); run_iasi_compress; exit"
    
echo "Finished with srun of run_iasi_compress"



