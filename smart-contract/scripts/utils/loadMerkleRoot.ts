import * as fs from "fs";
import * as path from "path";

function loadMerkleRoot(filePath: string): string | undefined {
  try {
    const absolutePath = path.resolve(filePath);
    const fileContent = fs.readFileSync(absolutePath, "utf-8");
    const jsonData = JSON.parse(fileContent);

    const merkleRoot = jsonData["merkleRoot"];
    if (!merkleRoot) {
      console.error("⚠️ Không tìm thấy key 'merkleRoot' trong file.");
      return undefined;
    }

    console.log("✅ Merkle Root:", merkleRoot);
    return merkleRoot;
    } catch (err) {
    console.error("❌ Lỗi khi load file JSON:", err);
    return undefined;
  }
}

export default loadMerkleRoot;