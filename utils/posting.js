const admin = require("firebase-admin");

const firestore = admin.firestore();

module.exports = async (collection, id, uid, commentor_profile, commentor_name, comment, createdAt, photo_path) => {
    return new Promise(async (resolve, reject) => {
        try {

            const ref = await firestore.collection(collection).doc(id)

            const _comment = await ref.update({ 
                posts: admin.firestore.FieldValue.arrayUnion({ 
                    uid: uid,
                    commentor_profile: commentor_profile,
                    commentor_name: commentor_name,
                    comment: comment, 
                    photo_path: photo_path,
                    createdAt:  createdAt
                }) 
            })
            
            resolve(_comment)
        } catch (error) {
            reject(error);
        }
    })
}