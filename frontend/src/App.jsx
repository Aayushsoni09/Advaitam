import { useState, useEffect } from 'react';
import axios from 'axios';
import ProductCard from './Components/ProductCard';
import './App.css';

function App() {
  const [products, setProducts] = useState([]);
  const [error, setError] = useState(null);

  useEffect(() => {
    axios
      .get('http://localhost:5000/api/products')
      .then((res) => setProducts(res.data))
      .catch((err) => {
        console.error(err);
        setError('Failed to load products');
      });
  }, []);

  return (
      <>
      <div className="min-h-screen bg-gray-50">
        {/* Navigation Bar */}
        <nav className="bg-white shadow-sm sticky top-0 z-50">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex justify-between items-center">
            {/* Logo */}
            <h1 className="text-2xl font-extrabold text-gray-900 tracking-tight">
              Advaitam<span className="text-indigo-600">Store</span>
            </h1>

            {/* Cart Button */}
            <button className="relative p-2 text-gray-600 hover:text-indigo-600 transition-colors">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="h-6 w-6"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"
                />
              </svg>

              <span className="absolute -top-1 -right-1 inline-flex items-center justify-center w-5 h-5 text-xs font-bold text-white bg-indigo-600 rounded-full">
                2
              </span>
            </button>
          </div>
        </nav>

        {/* Main Content */}
        <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
          <div className="text-center mb-10">
            <h2 className="text-3xl font-extrabold text-gray-900">
              Featured Collection
            </h2>
            <p className="mt-2 text-lg text-gray-500">
              Premium quality, delivered instantly.
            </p>
          </div>

          {/* Error Message */}
          {error && (
            <p className="text-center text-red-500 mb-6">{error}</p>
          )}

          {/* Product Grid */}
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                    {products.map((product) => (
                      <ProductCard key={product.id} product={product} />
                    ))}
                  </div>
        </main>
      </div>
    </>
  );
}

export default App;
