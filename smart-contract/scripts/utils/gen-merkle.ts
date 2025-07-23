import { exec } from "child_process";

export default function run_merkle() {
  exec("npm run merkle", (error, stdout, stderr) => {
    if (error) {
      console.error("❌ Lỗi khi chạy lệnh merkle:", error.message);
      return;
    }

    if (stderr) {
      console.error("⚠️ stderr:", stderr);
    }

    console.log("✅ Lệnh 'npm run merkle' đã chạy xong!");
    console.log(stdout);
  });
}
