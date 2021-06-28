const admin = require("firebase-admin");

const firestore = admin.firestore();

module.exports = async (collection, id, uid, commentor_profile, commentor_name, comment, createdAt) => {
    return new Promise(async (resolve, reject) => {
        try {

            const ref = await firestore.collection(collection).doc(id)

            const _comment = await ref.update({ 
                comments: admin.firestore.FieldValue.arrayUnion({ 
                    uid: uid,
                    commentor_profile: commentor_profile,
                    commentor_name: commentor_name,
                    comment: comment, 
                    createdAt:  createdAt
                }) 
            })
            
            resolve(_comment)
        } catch (error) {
            reject(error);
        }
    })
}