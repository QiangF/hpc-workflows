#!/bin/bash
# Gromacs MPI+OpenMP+CUDA SubmitScript
##########################################################################
#SBATCH -J GROMACS_JOB
#SBATCH --time=00:10:00     # Walltime
#SBATCH -A uoa99999         # Project Account
#SBATCH --mem-per-cpu=7G  # memory/cpu 
#SBATCH --ntasks=4          # number of tasks
#SBATCH --ntasks-per-node=2 # number of tasks per node
#SBATCH --cpus-per-task=6   # 4 OpenMP Threads
#SBATCH -N 2
#SBATCH --gres=gpu:2        # GPUs per node
#SBATCH -C sb
##########################################################################
###  Load the Enviroment Modules for Gromacs 4.5.4
ml GROMACS/4.6.5-goolf-1.5.14-hybrid-CUDA-6.0.37
##########################################################################
###  Transfering the data to the local disk  ($SCRATCH_DIR)
cd $SCRATCH_DIR
cp /share/test/GROMACS/NeSI.GROMACS_Davoud_Zare/input/* .
##########################################################################
###  Run the Parallel Program
srun grompp_mpi -f md_gpu.mdp -c BSAm_md1.gro -t BSAm_md1.cpt -p decane_3272.top -o BSAm_md2
srun mdrun_mpi -ntomp 6 -gpu_id 01 -nsteps 1000 -noconfout -deffnm BSAm_md2 -nb gpu
##########################################################################
###  Transfering the results to the home directory ($HOME)
cp -pr $SCRATCH_DIR /share/test/GROMACS/NeSI.GROMACS_Davoud_Zare/results/
