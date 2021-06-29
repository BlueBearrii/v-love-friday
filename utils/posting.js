const admin = require("firebase-admin");

const firestore = admin.firestore();

module.exports = async (collection, id, uid, commentor_profile, commentor_name, comment, createdAt, photo_path) => {
    return new Promise(async (resolve, reject) => {
        try {
            const post =await firestore.collection(collection).add({
                uid: uid,
                tripId: id,
                commentor_profile: commentor_profile,
                commentor_name: commentor_name,
                comment: comment,
                photo_path: photo_path,
                createdAt: createdAt
            }) 
            resolve({ message: "done", post })
        } catch (error) {
            reject(error);
        }
    })
}