const express = require("express");
const upload_image = require("../utils/upload_image");

exports.testUpload = async (req, res) => {
  const { file } = req;
  const { path, name } = req.body;

  try {
    const upload = await upload_image(file, path, name);
    res.status(200).json({message : upload})
  } catch (error) {
    res.status(500).json({status : "error"})
  }
}