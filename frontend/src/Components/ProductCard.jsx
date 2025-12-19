const ProductCard = ({ product }) => {
  return (
    <div className="bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow duration-300 border border-gray-100 flex flex-col">
      {/* Image Container - Fixed Height */}
      <div className="h-48 w-full overflow-hidden bg-gray-200 relative group">
          <img 
              src={product.image} 
              alt={product.name} 
              className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
          />
      </div>

      {/* Content */}
      <div className="p-4 flex flex-col flex-grow">
        <span className="text-xs uppercase tracking-wider text-indigo-600 font-semibold mb-1">
            {product.category}
        </span>
        
        {/* Title truncated to 2 lines max */}
        <h2 className="text-sm font-bold text-gray-800 mb-2 line-clamp-2 min-h-[2.5rem]">
            {product.name}
        </h2>
        
        {/* Price & Button Section */}
        <div className="mt-auto flex justify-between items-center pt-3 border-t border-gray-50">
          <span className="text-lg font-bold text-gray-900">
            ${product.price.toFixed(2)}
          </span>
          <button className="bg-gray-900 text-white text-xs font-medium px-3 py-2 rounded hover:bg-gray-700 transition-colors">
            Add to Cart
          </button>
        </div>
      </div>
    </div>
  );
};

export default ProductCard;