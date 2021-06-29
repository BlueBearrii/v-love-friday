const multer  = require('multer')
const upload = multer({ dest: 'uploads/', storage : multer.memoryStorage() })

module.exports = upload;