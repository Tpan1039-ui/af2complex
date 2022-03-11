#!/bin/bash
#
# An example script of a AF2Complex run for predicting structural models of complex targets
#
#
# You need to take care of these two items, which are dependent on your installation.
#. load_alphafold  ## set up proper AlphaFold conda environment.
DATA_DIR=$HOME/scratch/afold/data ## change this to point to alphafold's DL parameter directory

### input targets
target_lst_file=test.lst  # a list of target with stoichiometry
fea_dir=af_fea   # directory to input feature pickle files
out_dir=af2c_mod # model output directory, $out_dir/$target

### run preset, note this is different from model_preset defined below
### This preset defined the number of recycles, ensembles, MSA cluster sizes (for monomer_ptm models)
preset=super   # up to 20 recycles, 1 ensemble.

### Choose neural network model(s) from ['model_1/2/3/4/5_multimer', 'model_1/2/3/4/5_multimer_v2', or 'model_1/2/3/4/5_ptm']
# Using AF2 multimer model released in version 2.1.1
#model=model_1_multimer,model_2_multime,rmodel_3_multimer,model_4_multimer,model_5_multimer
# Using AF2 multimer model released in version 2.2.0
#model=model_1_multimer_v2,model_2_multime_v2,rmodel_3_multimer_v2,model_4_multimer_v2,model_5_multimer_v2
model=model_1_multimer_v2,model_2_multimer_v2
# Using AF2 monomer_ptm model released in version 2.0.1
#model=model_1_ptm,model_2_ptm,model_3_ptm,model_4_ptm,model_5_ptm

### Choose model_preset from: ['monomer_ptm', 'multimer', 'multimer_np']
# Notes:
#   - multimer_np: apply multimer DL model to joined monomer features without MSA pairing
#   - multimer: apply multimer DL model to paired MSAs (pre-generated by AlphaFold-Multimer's data pipeline)
#   - monomer_ptm: applying original AF monomer DL model with the capability of predicting TM-score
#
#   This preset can be applied to both monomeric and multimeric model prediction.
#   You need to specify also approriate model names compatible with the model preset you choose.
#
model_preset=multimer_np

recycling_setting=1   # output metrics but not saving pdb files during intermediate recycles

echo "Info: input feature directory is $fea_dir"
echo "Info: result output directory is $out_dir"
echo "Info: model preset is $model_preset"

# AF2Complex source code directory
af_dir=../src

# for use with checkpoint_tag that enables checkpoint saving, disabled by default
#ckpt_tag=ckpt

python -u $af_dir/run_af2c_mod.py --target_lst_path=$target_lst_file \
  --data_dir=$DATA_DIR --output_dir=$out_dir --feature_dir=$fea_dir \
  --model_names=$model \
  --preset=$preset \
  --model_preset=$model_preset \
  --save_recycled=$recycling_setting \
  #--checkpoint_tag=$ckpt_tag \
