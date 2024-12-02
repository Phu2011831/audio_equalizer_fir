def wav_to_hex(input_wav_file, output_hex_file):
    try:
        # Mở file .wav để đọc nhị phân
        with open(input_wav_file, 'rb') as wav_file:
            # Đọc toàn bộ nội dung file vào bộ nhớ
            wav_data = wav_file.read()
        
        # Mở file .hex để ghi dữ liệu hex
        with open(output_hex_file, 'w') as hex_file:
            # Chuyển đổi dữ liệu thành dạng hexadecimal và ghi vào file
            hex_file.write(wav_data.hex())
        
        print(f"Đã chuyển đổi {input_wav_file} thành {output_hex_file} thành công.")
    
    except Exception as e:
        print(f"Đã xảy ra lỗi: {e}")

# Đường dẫn tới file .wav đầu vào và file .hex đầu ra
input_wav = 'C:/altera/13.1/test_audio_equalizer/audio/example_input_audio_with_sine_noise.wav'  # Thay thế bằng đường dẫn file .wav của bạn
output_hex = 'output_file.hex'  # Thay thế bằng đường dẫn file .hex bạn muốn tạo

# Gọi hàm để chuyển đổi
wav_to_hex(input_wav, output_hex)
