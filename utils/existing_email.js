const admin = require("firebase-admin");

const auth = admin.auth();

module.exports = async (email) => {
    return new Promise(async (resolve, reject) => {
        try {
            const existing = await auth.getUserByEmail(email);
            resolve(existing)
        } catch (error) {
            reject(error);
        }
    })
}