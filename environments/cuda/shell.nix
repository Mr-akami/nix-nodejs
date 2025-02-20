# nixpkgsをインポートするための基本的な関数定義
{ packages ? import <nixpkgs> {} }:

# 開発シェル環境の定義
packages.mkShell {
  # 必要なパッケージを指定
  buildInputs = with packages; [
    # CUDA関連のパッケージ
    cudatoolkit
    linuxPackages.nvidia_x11
    
    # 開発ツール
    gcc
    gnumake
  ];

  # 環境変数の設定
  shellHook = ''
    export CUDA_PATH=${packages.cudatoolkit}
    export LD_LIBRARY_PATH=${packages.linuxPackages.nvidia_x11}/lib:${packages.cudatoolkit}/lib64:$LD_LIBRARY_PATH
    export EXTRA_LDFLAGS="-L/lib -L${packages.linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
    
    echo "CUDA development environment activated"
    echo "----------------------------------------"
    echo "CUDA version: $(nvcc --version | grep release | awk '{print $5}' | cut -c2-)"
    echo "----------------------------------------"
  '';
} 