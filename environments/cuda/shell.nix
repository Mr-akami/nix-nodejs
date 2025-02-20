# nixpkgsをインポートするための基本的な関数定義
{ packages ? import <nixpkgs> {
    config = {
      allowUnfree = true;
      cudaSupport = true;
    };
  }
}:

# 開発シェル環境の定義
packages.mkShell {
  # 必要なパッケージを指定
  buildInputs = with packages; [
    # CUDA関連
    cudatoolkit
    cudaPackages.cudnn
    linuxPackages.nvidia_x11
    
    # Python環境
    python311
    (python311.pkgs.tensorflow.override {
      cudaSupport = true;
    })
    python311Packages.pip
    python311Packages.setuptools
    
    # ビルドツール
    gcc
    gnumake
  ];

  # 環境変数の設定
  shellHook = ''
    export CUDA_PATH=${packages.cudatoolkit}
    export LD_LIBRARY_PATH=${packages.linuxPackages.nvidia_x11}/lib:${packages.cudatoolkit}/lib64:${packages.cudaPackages.cudnn}/lib:$LD_LIBRARY_PATH
    export EXTRA_LDFLAGS="-L/lib -L${packages.linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
    export XLA_FLAGS=--xla_gpu_cuda_data_dir=${packages.cudatoolkit}
    export CUDNN_PATH="${packages.cudaPackages.cudnn}"
    
    echo "CUDA + TensorFlow development environment activated"
    echo "----------------------------------------"
    echo "CUDA version: $(nvcc --version | grep release | awk '{print $5}' | cut -c2-)"
    echo "Python version: $(python3 --version)"
    echo "TensorFlow version: $(python3 -c 'import tensorflow as tf; print(tf.__version__)')"
    echo "----------------------------------------"
    
    # GPUの確認用Pythonスクリプトを作成
    cat > check_gpu.py << 'EOF'
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
EOF
    
    echo "To check GPU availability, run: python3 check_gpu.py"
  '';
} 