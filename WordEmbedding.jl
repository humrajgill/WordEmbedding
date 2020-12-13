using Word2Vec
using Gadfly


print("Starting Word Vectors...\n\n")

#= Load trained file if it exists else start training =#
if (isfile("text-vectors.txt"))
    model = wordvectors("text-vectors.txt")
    print("Trained model found and loaded.\n")
else
    print("Begin Training...\n")
    word2vec("text", "text-vectors.txt", verbose = true)
end

print("Similar words: \n")
print("Enter a word: ")
word = readline()

get_vector(model, word)

function similarWords(word, size)
    return cosine_similar_words(model, word, size)
end

similar = similarWords(word, 5)

print("Similar words: $similar \n")

print("Similarity of two words: \n")
print("Enter the first word: ")
word1 = readline()
print("Enter the second word: ")
word2 = readline()

function similarPercent(word1, word2)
    return similarity(model, word1, word2) * 100
end

similarity_percentage = similarPercent(word1, word2)
print("Similarity Percentage of $word1 and $word2: $similarity_percentage%\n")

print("Graphing similar words: \n")
print("Enter a word: ")
word = readline()


function graphSimilarWords(word)
    words = vocabulary(model)
    idx = index(model, word)
    words[idx]
    idxs, distances = cosine(model, word, 10)
    plot(x=words[idxs], y=distances)
end

graphSimilarWords(word)

#================= Word Clusters =================#
# Similar words at start of array, dissimilar words at end of array
print("\n\nStarting Word Clusters...\n")
#= Load trained file if it exists else start training =#
if (isfile("text-clusters.txt"))
    model2 = wordclusters("text-clusters.txt")
    print("Trained model found and loaded.\n")
else
    print("Begin Training...\n")
    word2clusters("text", "text-clusters.txt", 100)
end


function WordClusters(word)
    clusterID = get_cluster(model2, word)
    return get_words(model2, clusterID)
end

print("Word Cluster of $word: $(WordClusters(word))\n")


#=
clusterWords = vocabulary(model2)

indx = index(model2, "human")

clusterID = get_cluster(model2, "human")

get_words(model2, clusterID)
=#

#================= Word Phrases =================#
print("\n\nStarting Word Phrases...\n")
#= Load trained file if it exists else start training =#
if (isfile("text-phrases-vectors.txt"))
    model3 = wordvectors("text-phrases-vectors.txt")
    print("Trained model found and loaded.\n")
else
    print("Begin Training...\n")
    word2phrase("text", "text-phrases")
    word2vec("text-phrases", "text-phrases-vectors.txt", verbose=true)
end


print("Similar Phrases: \n")
print("Enter a phrase (example: san_jose): ")
phrase = readline()

function similarPhrases(phrase)
    return cosine_similar_words(model3, phrase)
end


print("Similar phrases of \"$phrase\": $(similarPhrases(phrase))\n")


#================= Analogy Questions & Word Combinations =================#
print("\n\nStarting Analogy Questions & Word Combinations...\n")
print("Analogy questions (a is to b as c is to ?): \n")

function wordCombinations(addingWords, removingWords, size)
    addWords = split(addingWords, "+")
    removeWords = split(removingWords, "-")
    return analogy_words(model, addWords, removeWords, size)
end

print("Example: king + woman - man = $(wordCombinations("king+woman", "man", 6))\n")
print("Example: snow + winter - summer = $(wordCombinations("snow+winter", "summer", 6))\n")

print("Enter a question (follow guidelines of the given examples above): ")
print("Adding words: ")
addingWords = readline()
print("Removing words: ")
removingWords = readline()
print("$addingWords - $removingWords = $(wordCombinations(addingWords, removingWords, 6))\n")


print("Graphing analogy questions (a is to b as c is to ?): \n")

function graphAnalogy(addingWords, removingWords, size)
    addWords = split(addingWords, "+")
    removeWords = split(removingWords, "-")
    words = vocabulary(model)
    idx = index(model, word)
    words[idx]
    indxs, distance = analogy(model, addWords, removeWords, size)
    plot(x=words[indxs], y=distance)
end

graphAnalogy("queen+man", "woman", 6)
