module Crypto.Hash.Equihash
( Proof(..)
, checkProof
, findProof
) where

import Control.Exception
import Data.Vector.Storable (Vector)
import qualified Data.Vector.Storable as V
import Foreign.C.Types
import Foreign.ForeignPtr
import Foreign.Marshal.Alloc
import Foreign.Ptr
import Foreign.Storable

import Crypto.Hash.Equihash.Bindings

data Proof = Proof
    { proof_n :: CUInt
    , proof_k :: CUInt
    , proof_seed :: CUInt
    , proof_nonce :: CUInt
    , proof_inputs :: Vector CUInt
    }

type CProof = Ptr ()

checkProof :: Proof -> IO Bool
checkProof (Proof n k seed nonce inputs) = V.unsafeWith inputs $ \ptr -> do
    retval <- bracket (c_equihash_create_proof n k seed nonce l ptr)
                      c_equihash_destroy_proof
                      c_equihash_check_proof
    return $! retval /= 0

  where
    l = fromIntegral (V.length inputs)

explodeProof :: CProof -> IO Proof
explodeProof p =
    mask_ $
    alloca $ \nptr ->
    alloca $ \kptr ->
    alloca $ \seedptr ->
    alloca $ \nonceptr ->
    alloca $ \sizeptr -> do
        arr <- c_equihash_explode_proof p nptr kptr seedptr nonceptr sizeptr
        arrptr <- newForeignPtr finalizerFree arr
        n <- peek nptr
        k <- peek kptr
        seed <- peek seedptr
        nonce <- peek nonceptr
        sz <- peek sizeptr
        let arrV = V.unsafeFromForeignPtr0 arrptr (fromIntegral sz)
        return $! Proof n k seed nonce arrV

findProof :: CUInt -> CUInt -> CUInt -> IO Proof
findProof n k seed =
    bracket (c_equihash_find_proof n k seed)
            c_equihash_destroy_proof
            explodeProof
