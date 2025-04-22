import numpy as np
import matplotlib.pyplot as plt
import glob
import os

#change before using

# 配置参数
INPUT_DIR = "1-1"               # 输入文件夹路径-
OUTPUT_DIR = "output_figures_1-1"   # 输出图片保存目录
FILE_PREFIX = "field_plot"      # 图片文件名前缀
START_NUM = 2                   # 起始文件编号 (2.txt)
END_NUM = 302                   # 结束文件编号 (302.txt)
STEP = 3                        # 文件编号间隔 (2, 5, 8,..., 302)
#change ^ before using



def plot_single_file(file_path, save_path=None):
    """绘制单个文件的曲线并保存"""
    data = np.loadtxt(file_path, delimiter=",")
    x = data[:, 0]  # 第一列: 频率
    y = np.sqrt(data[:, 1] ** 2 + data[:, 2] ** 2)  #norm
    #y = abs(data[:, 1])  # 第二列: 电场强度+绝对值

    plt.figure(figsize=(10, 6))
    plt.plot(x, y, 'b-', linewidth=1.5)
    plt.xlabel("Frequency (Hz)")
    plt.ylabel("Electric Field Strength")
    plt.title(f"Data from {os.path.basename(file_path)}")
    plt.grid(True)

    if save_path:
        os.makedirs(os.path.dirname(save_path), exist_ok=True)
        plt.savefig(save_path, dpi=300, bbox_inches='tight')
        plt.close()  # 关闭图形以释放内存
    else:
        plt.show()

def batch_plot_files():
    """批量处理从START_NUM到END_NUM的文件"""
    # 生成要处理的文件列表 (2.txt, 5.txt,..., 302.txt)
    file_numbers = range(START_NUM, END_NUM + 1, STEP)
    file_paths = [os.path.join(INPUT_DIR, f"{n}.txt") for n in file_numbers]

    # 检查文件是否存在
    missing_files = [f for f in file_paths if not os.path.exists(f)]
    if missing_files:
        print(f"警告: 以下文件不存在，将被跳过:\n{missing_files}")

    # 批量绘制并保存
    for file_path in file_paths:
        if os.path.exists(file_path):
            file_name = os.path.splitext(os.path.basename(file_path))[0]
            save_path = os.path.join(OUTPUT_DIR, f"{FILE_PREFIX}_{file_name}.png")
            print(f"正在处理: {file_path} -> {save_path}")
            plot_single_file(file_path, save_path)

    print(f"\n处理完成！图片已保存至: {os.path.abspath(OUTPUT_DIR)}")

if __name__ == "__main__":
    batch_plot_files()
