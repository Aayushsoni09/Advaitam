import { useState, useEffect } from 'react';
import './App.css';
import { Routes, Route } from "react-router-dom";
import Home from "./components/Home";
import Cart from "./components/Cart";
import PaymentSuccess from "./components/PaymentSuccess";

function App() {

  return (
    <Routes>
      <Route path="/payment-success" element={<PaymentSuccess />} />
      <Route path="/" element={<Home />} />
      <Route path="/cart" element={<Cart />} />
    </Routes>
  );
}

export default App;
