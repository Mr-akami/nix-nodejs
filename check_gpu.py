import tensorflow as tf

# TensorFlowのログレベルを設定
tf.get_logger().setLevel('INFO')

# 利用可能なデバイスを表示
print("\nAvailable TensorFlow Devices:")
for device in tf.config.list_physical_devices():
    print(f"  {device.device_type}: {device.name}")

# GPUが利用可能かどうかを確認
gpus = tf.config.list_physical_devices('GPU')
print(f"\nNumber of GPUs Available: {len(gpus)}")
if gpus:
    for gpu in gpus:
        print(f"GPU Device: {gpu}")
        
    # GPUのメモリ設定
    try:
        for gpu in gpus:
            tf.config.experimental.set_memory_growth(gpu, True)
        print("\nGPU memory growth is enabled")
    except RuntimeError as e:
        print(f"\nError setting GPU memory growth: {e}")
else:
    print("\nNo GPU devices found. Running on CPU only.")

# TensorFlowの設定情報を表示
print("\nTensorFlow Build Information:")
print(f"Built with CUDA: {tf.test.is_built_with_cuda()}")
print(f"Built with GPU support: {tf.test.is_built_with_gpu_support()}")
