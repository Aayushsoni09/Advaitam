import { useSearchParams, useNavigate } from "react-router-dom";
import { useCart } from "../context/CartContext";

export default function PaymentSuccess() {
  const [params] = useSearchParams();
  const navigate = useNavigate();
  const { clearCart } = useCart();

  const orderId = params.get("orderId");

  return (
    <div className="min-h-screen flex flex-col items-center justify-center">
      <h1 className="text-3xl font-bold text-emerald-600">
        Payment Successful 🎉
      </h1>

      <p className="mt-4">Order ID: {orderId}</p>

      <button
        onClick={() => {
          clearCart();
          navigate("/");
        }}
        className="mt-6 px-6 py-2 bg-indigo-600 text-white rounded-lg"
      >
        Continue Shopping
      </button>
    </div>
  );
}
