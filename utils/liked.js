const admin = require("firebase-admin");

const firestore = admin.firestore();

module.exports = async (collection, id, uid) => {
    return new Promise(async (resolve, reject) => {
        try {

            const ref = await firestore.collection(collection).doc(id)

            const getExist = await (await ref.get()).data().likes
 
            const isExist = await getExist.includes(uid)

            if (isExist) {
                const _romoveLike = await ref.update({
                    likes: admin.firestore.FieldValue.arrayRemove(uid)
                })

                resolve({status: "dislike", message:_romoveLike});
            } else {
                const _updateLike = await ref.update({
                    likes: admin.firestore.FieldValue.arrayUnion(uid)
                })

                resolve({status: "like", message:_updateLike});
            }

        } catch (error) {
            reject(error);
        }
    })
}