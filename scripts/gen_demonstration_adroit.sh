# bash scripts/gen_demonstration_adroit.sh door 50
# bash scripts/gen_demonstration_adroit.sh hammer 50
# bash scripts/gen_demonstration_adroit.sh pen 50

cd third_party/VRL3/src

task=${1}
num_episodes=${2:-10}  # Default to 10 if not specified

CUDA_VISIBLE_DEVICES=0 python gen_demonstration_expert.py --env_name $task \
                        --num_episodes ${num_episodes} \
                        --root_dir "../../../3D-Diffusion-Policy/data/" \
                        --expert_ckpt_path "../ckpts/vrl3_${task}.pt" \
                        --img_size 84 \
                        --not_use_multi_view \
                        --use_point_crop
