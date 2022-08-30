#!/bin/bash
#
# An example script of an AF2Complex run for predicting structural models
# of a multimeric target using the original AF2 model weights and cyclic MSA pairing.
# Checkpoint is enabled in this example.

# You need to take care of these two items, which are dependent on your installation.
# 1) activate your conda environment for AlphaFold if you use conda
# . load_alphafold
# 2) change this to point to alphafold's deep learning model parameter directory
DATA_DIR=$HOME/scratch/afold/data

### input targets
target_lst_file=targets/example4.lst  # a list of target with stoichiometry
fea_dir=af2c_fea   # directory to input feature pickle files
out_dir=af2c_mod # model output directory, s.t. output files will be on $out_dir/$target

### run preset, note this is different from model_preset defined below
### This preset defined the number of recycles, ensembles, MSA cluster sizes (for monomer_ptm models)
preset=expert # up to 20 recycles, 1 ensemble.

### Choose neural network model(s) from ['model_1/2/3/4/5_multimer', 'model_1/2/3/4/5_multimer_v2', or 'model_1/2/3/4/5_ptm']
# Using AF2 monomer_ptm model released in alphafold2 version 2.0.1
model=model_5_ptm

### Choose model_preset from: ['monomer_ptm', 'multimer', 'multimer_np']
# Notes:
#   - multimer_np: apply multimer DL model to joined monomer features
#   - multimer: apply multimer DL model to paired MSAs (pre-generated by AlphaFold-Multimer's data pipeline)
#   - monomer_ptm: applying original AF monomer DL model with the capability of predicting TM-score
#
#   This preset can be applied to both monomeric and multimeric model prediction.
#   You need to specify also approriate model names compatible with the model preset you choose.
#
model_preset=monomer_ptm
msa_pairing=cyclic

recycling_setting=1   # output metrics but not saving pdb files during intermediate recycles

echo "Info: input feature directory is $fea_dir"
echo "Info: result output directory is $out_dir"
echo "Info: model preset is $model_preset"

# This example requires long recycles. If you cannot run long recycles in one run,
# you can reduce the max_recycles in each run, e.g., 2, and activate the checkpoint option
# as shown below to run multiple times.
max_recycles=8
# for use with checkpoint_tag that enables checkpoint saving
ckpt_tag=ckpt

# use unfied memory on a multi-gpu node to tackle a large target
export TF_FORCE_UNIFIED_MEMORY=1
export XLA_PYTHON_CLIENT_MEM_FRACTION=4   # preallocate memory of this number x 1 GPU memory


# AF2Complex source code directory
af_dir=../src
python -u $af_dir/run_af2c_mod.py --target_lst_path=$target_lst_file \
  --data_dir=$DATA_DIR --output_dir=$out_dir --feature_dir=$fea_dir \
  --model_names=$model \
  --preset=$preset \
  --model_preset=$model_preset \
  --save_recycled=$recycling_setting \
  --max_recycles=$max_recycles \
  --msa_pairing=$msa_pairing \
  --checkpoint_tag=$checkpoint_tag \
