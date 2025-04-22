import numpy as np
import matplotlib.pyplot as plt
import glob
import os

# 配置参数
#3.4Ghz对应750
#3.18Ghz 对应700
INPUT_DIR = '1-1'  # 输入文件夹路径
OUTPUT_DIR = 'frequency_range_plots_1-1'  # 输出图片保存目录

# 获取所有txt文件并按数字顺序排序
file_list = sorted(glob.glob(f'{INPUT_DIR}/[0-9]*.txt'),
                   key=lambda x: int(os.path.splitext(os.path.basename(x))[0]))

# 读取第一个文件获取所有特征频率列表
first_file_data = np.loadtxt(file_list[0], delimiter=",")
all_frequencies = first_file_data[:, 0]  # 所有特征频率

# 显示频率范围信息
print(f"频率范围: {all_frequencies[0]:.1f} Hz 到 {all_frequencies[-1]:.1f} Hz (共{len(all_frequencies)}个频率点)")

# 创建输出目录
os.makedirs(OUTPUT_DIR, exist_ok=True)


def plot_and_save_frequency_range(start_idx, end_idx):
    """绘制并保存指定频率范围内的所有图像"""
    for i in range(start_idx, end_idx + 1):
        target_frequency = all_frequencies[i]

        # 收集所有位置的数据
        target_data = []
        for file_path in file_list:
            position = int(os.path.splitext(os.path.basename(file_path))[0])
            file_data = np.loadtxt(file_path, delimiter=",")
            #e_field = file_data[i, 1]  # 直接使用频率索引获取数据
            #e_field = abs(file_data[i, 1])  # 取绝对值
            e_real = file_data[i, 1]  # 实部
            e_imag = file_data[i, 2]  # 虚部
            e_norm = np.sqrt(e_real ** 2 + e_imag ** 2)  # 计算电场模
            target_data.append((position, e_norm))

        # 排序和绘图
        target_data_sorted = sorted(target_data, key=lambda x: x[0])
        positions = [x[0] for x in target_data_sorted]
        e_fields = [x[1] for x in target_data_sorted]

        plt.figure(figsize=(10, 6))
        plt.plot(positions, e_fields, 'b-o', linewidth=2, markersize=5)
        plt.xlabel('Position (from file name)')
        plt.ylabel('Electric Field Strength')
        plt.title(f'Electric Field at {target_frequency:.1f} Hz')
        plt.grid(True)

        # 保存图片
        filename = f"freq_{target_frequency:.1f}_Hz.png"
        plt.savefig(os.path.join(OUTPUT_DIR, filename), dpi=300, bbox_inches='tight')
        plt.close()
        print(f"已保存: {filename}")


# 用户交互选择范围
while True:
    try:
        print("\n当前可用频率索引范围: 0 到", len(all_frequencies) - 1)
        start_idx = input("请输入起始频率序号 (输入q退出): ")
        if start_idx.lower() == 'q':
            break

        end_idx = input("请输入结束频率序号: ")
        start_idx, end_idx = int(start_idx), int(end_idx)

        # 验证范围有效性
        if 0 <= start_idx <= end_idx < len(all_frequencies):
            print(f"\n正在处理频率 {all_frequencies[start_idx]:.1f} Hz 到 {all_frequencies[end_idx]:.1f} Hz...")
            plot_and_save_frequency_range(start_idx, end_idx)
            print(f"\n处理完成！共生成 {end_idx - start_idx + 1} 张图片")
        else:
            print("错误: 无效的范围输入！")

    except ValueError:
        print("错误: 请输入有效的数字！")

print(f"\n所有图片已保存至: {os.path.abspath(OUTPUT_DIR)}")