# nixpkgsをインポートするための基本的な関数定義
{ packages ? import <nixpkgs> {
    config = {
      allowUnfree = true;
    };
  }
}:

# 開発シェル環境の定義
packages.mkShell {
  # 必要なパッケージを指定
  buildInputs = with packages; [
    # CUDA関連
    cudatoolkit
    cudnn
    
    # Python環境
    python311
    python311Packages.pytorch-bin
    python311Packages.pip
    python311Packages.setuptools
  ];

  # 環境変数の設定
  shellHook = ''
    export CUDA_HOME=${packages.cudatoolkit}
    export LD_LIBRARY_PATH=${packages.cudatoolkit}/lib:${packages.cudnn}/lib:$LD_LIBRARY_PATH
    export PATH=${packages.cudatoolkit}/bin:$PATH
    export CUDA_VISIBLE_DEVICES=0
    
    echo "CUDA + PyTorch development environment activated"
    echo "----------------------------------------"
    echo "CUDA version: $(nvcc --version | grep release | awk '{print $5}' | cut -c2-)"
    echo "Python version: $(python3 --version)"
    echo "PyTorch version: $(python3 -c 'import torch; print(torch.__version__)')"
    echo "----------------------------------------"
    
    # GPUの確認用Pythonスクリプトを作成
    cat > check_gpu.py << 'EOF'
import torch

print("PyTorch version:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())

if torch.cuda.is_available():
    print("CUDA version:", torch.version.cuda)
    print("GPU device name:", torch.cuda.get_device_name(0))
    print("Number of GPUs:", torch.cuda.device_count())
    
    # 簡単なテンソル演算でGPUが使えることを確認
    x = torch.randn(3, 3).cuda()
    print("\nTest tensor on GPU:")
    print(x)
else:
    print("No GPU available. Running on CPU only.")
EOF
    
    echo "To check GPU availability, run: python3 check_gpu.py"
  '';
} 