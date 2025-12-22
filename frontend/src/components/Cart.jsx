import { useCart } from "../context/CartContext";
import { useNavigate } from "react-router-dom";

export default function Cart() {
  const { cart, removeFromCart, clearCart } = useCart();
  const navigate = useNavigate();

  const handleBuyNow = async () => {
    const res = await fetch("/api/orders/create", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ items: cart }),
    });

    const data = await res.json();

    if (data.paymentUrl) {
      window.location.href = data.paymentUrl;
    }
  };

  const total = cart.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0
  );

  return (
    <div className="max-w-4xl mx-auto p-6">
      <h1 className="text-2xl font-bold mb-6">Your Cart</h1>

      {/* EMPTY CART */}
      {cart.length === 0 && (
        <div className="text-center mt-10">
          <p className="text-gray-600 mb-4 text-lg">
            Add some items
          </p>

          <button
            onClick={() => navigate("/")}
            className="px-5 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition"
          >
            Go to Home
          </button>
        </div>
      )}

      {/* CART ITEMS */}
      {cart.map((item) => (
        <div
          key={item.id}
          className="flex items-center gap-4 mb-4 border-b pb-4"
        >
          <img
            src={item.images?.[0]}
            alt={item.title}
            className="w-20 h-20 object-cover rounded-lg"
            onError={(e) => {
              e.target.src =
                "https://via.placeholder.com/100x100?text=No+Image";
            }}
          />

          <div className="flex-1">
            <h2 className="font-semibold">{item.title}</h2>
            <p className="text-sm text-gray-500">
              Qty: {item.quantity}
            </p>
            <p className="font-medium">₹{item.price}</p>
          </div>

          <button
            onClick={() => removeFromCart(item.id)}
            className="text-red-500 hover:text-red-700"
          >
            Remove
          </button>
        </div>
      ))}

      {/* CART SUMMARY */}
      {cart.length > 0 && (
        <>
          <p className="text-lg font-bold mt-6">
            Total: ₹{total}
          </p>

          <div className="flex justify-between items-center mt-6">
            {/* ADD MORE ITEMS */}
            <button
              onClick={() => navigate("/")}
              className="text-indigo-600 hover:underline"
            >
              Want add more items?
            </button>

            {/* BUY NOW */}
            <button
              onClick={handleBuyNow}
              className="px-6 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition"
            >
              Buy Now
            </button>
          </div>
        </>
      )}
    </div>
  );
}
