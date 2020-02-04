{-# LANGUAGE ForeignFunctionInterface #-}

module Crypto.Hash.Equihash.Bindings where

import Foreign
import Foreign.C.Types

foreign import ccall unsafe "cbits.h equihash_create_proof"
    c_equihash_create_proof
        :: CUInt -> CUInt -> CUInt -> CUInt -> CInt -> Ptr CUInt -> IO (Ptr ())

foreign import ccall unsafe "cbits.h equihash_destroy_proof"
    c_equihash_destroy_proof :: Ptr () -> IO ()

foreign import ccall safe "cbits.h equihash_find_proof"
    c_equihash_find_proof :: CUInt -> CUInt -> CUInt -> IO (Ptr ())

foreign import ccall unsafe "cbits.h equihash_check_proof"
    c_equihash_check_proof :: Ptr () -> IO CInt

foreign import ccall unsafe "cbits.h equihash_explode_proof"
    c_equihash_explode_proof :: Ptr () -> Ptr CUInt -> Ptr CUInt -> Ptr CUInt
                             -> Ptr CUInt -> Ptr CInt -> IO (Ptr CUInt)
