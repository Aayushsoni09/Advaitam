const ProductCard = ({ product }) => {
  return (
    <div
                    key={product.id}
                    className="bg-white rounded-xl shadow-sm hover:shadow-md transition p-4"
                  >
                    <img
                      src={product.images?.[0]}
                      alt={product.title}
                      className="h-48 w-full object-cover rounded-lg mb-4"
                      onError={(e) => {
                        e.target.src =
                          "https://via.placeholder.com/300x300?text=No+Image";
                      }}
                    />

                    <h3 className="text-sm font-semibold text-gray-900 line-clamp-2">
                      {product.title}
                    </h3>

                    <p className="text-xs text-gray-500 mt-1">
                      {product.category?.name}
                    </p>

                    <div className="flex justify-between items-center mt-4">
                      <span className="text-lg font-bold text-indigo-600">
                        ₹{product.price}
                      </span>

                      <button className="px-3 py-1 text-sm bg-zinc-600 text-white rounded-lg hover:bg-zinc-700 transition">
                        Add to Cart
                      </button>
                    </div>
                  </div>
  );
};

export default ProductCard;