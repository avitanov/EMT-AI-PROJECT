
import './App.css'
import Layout from "./ui/components/layout/Layout/Layout.jsx";
import ProductsPage from "./ui/pages/ProductsPage.jsx";
import {BrowserRouter, Routes, Route} from "react-router";
import ProductDetails from "./ui/components/products/ProductDetails/ProductDetails.jsx";
function App() {

  return (
      <BrowserRouter>
          <Routes>
          {/* /products/* all under your Layout */}
          <Route path="products" element={<Layout />}>

              {/* /products → show all products (or all categories) */}
              <Route index element={<ProductsPage />} />

              {/* /products/:category → filtered list by category */}
              <Route path=":category" element={<ProductsPage />} />

              {/* /products/:category/:id → product detail */}
              <Route path=":category/:id" element={<ProductDetails />} />

          </Route>
          </Routes>
      </BrowserRouter>
  )
}

export default App
