const admin = require("firebase-admin");
const { format } = require('util');
const sharp = require('sharp');

const storage = admin.storage().bucket();

module.exports = async (file, path, name) => {
  return new Promise(async (resolve, reject) => {
    const pathName = path + "/" + name
    const url = format(
      `https://firebasestorage.googleapis.com/v0/b/${storage.name}/o/${path}${name}?alt=media`);


    const resizeBuffer = await sharp(file.buffer).resize(1280,720).toBuffer()

    try {
      const _file = await storage.file(pathName);

      const blobStream = await _file.createWriteStream({
        metadata: {
          contentType: file.mimetype,
          firebaseStorageDownloadTokens: null,
        },
      });

      blobStream.on("error", (error) => {
        resolve({ status: "error", message: error })
      });

      blobStream.on("finish", async () => {
        resolve({ status: "success", message: url })
      });

      blobStream.end(resizeBuffer);
    } catch (error) {
      reject({ status: "error" });
    }
  })
}