#!/bin/bash
#
# usage: 
#
# 

# sbatch options
#SBATCH --job-name=RUN_IASI_COMPRESS
# partition = dev/batch
#SBATCH --partition=high_mem
# qos = short/normal/medium/long/long_contrib
#SBATCH --qos=short+
#SBATCH --account=pi_strow
#SBATCH -N1
#SBATCH --mem-per-cpu=18000
#SBATCH --cpus-per-task 1
###SBATCH --array=1-540
#SBATCH --time=00:50:00

#SBATCH -o /home/sbuczko1/LOGS/sbatch/run_iasi_compress-%A_%a.out
#SBATCH -e /home/sbuczko1/LOGS/sbatch/run_iasi_compress-%A_%a.err

# matlab options
MATLAB=matlab
MATOPT=' -nojvm -nodisplay -nosplash'

echo "Executing srun of run_iasi_compress"
$MATLAB $MATOPT -r "addpath(genpath('~/git/rtp_prod2')); addpath('/home/sbuczko1/git/matlib.SERGIO/aslutil'); run_iasi_compress; exit"
    
echo "Finished with srun of run_iasi_compress"



