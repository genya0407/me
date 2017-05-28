--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE StandaloneDeriving #-}
import           Data.Monoid (mappend, (<>))

import           Hakyll

import           Data.ByteString.Char8 (pack)
import           Network.HTTP.Simple
import           GHC.Generics
import           Data.Aeson
import           Data.Aeson.Types
import           System.Environment (getEnv)

--------------------------------------------------------------------------------

data QiitaUser = QiitaUser
    { user_description :: String
    , user_facebook_id :: String
    , user_followees_count :: Int
    , user_followers_count :: Int
    , user_github_login_name :: String
    , user_id :: String
    , user_items_count :: Int
    , user_linkedin_id :: String
    , user_location :: String
    , user_name :: String
    , user_organization :: String
    , user_permanent_id :: Int
    , user_profile_image_url :: String
    , user_twitter_screen_name :: Maybe String
    , user_website_url :: String
    } deriving (Generic, Show)

instance FromJSON QiitaUser where
    parseJSON = genericParseJSON defaultOptions { fieldLabelModifier = drop 5 }

data QiitaPost = QiitaPost
    { post_rendered_body :: String
    , post_body :: String
    , post_coediting :: Bool
    , post_created_at :: String
    , post_group :: Maybe String
    , post_id :: String
    , post_private :: Bool
    , post_tags :: [QiitaTag]
    , post_title :: String
    , post_updated_at :: String
    , post_url :: String
    , post_user :: Maybe QiitaUser
    } deriving (Generic, Show)

instance FromJSON QiitaPost where
    parseJSON = genericParseJSON defaultOptions { fieldLabelModifier = drop 5 }

data QiitaTag = QiitaTag
    { tag_name :: String
    , tag_versions :: [String]
    } deriving (Generic, Show)

instance FromJSON QiitaTag where
    parseJSON = genericParseJSON defaultOptions { fieldLabelModifier = drop 4 }

getQiitaCtx :: IO (Context String)
getQiitaCtx = do
    request <- parseRequest "https://qiita.com/api/v2/items?query=user:genya0407"
    qiita_access_token <- getEnv "QIITA_ACCESS_TOKEN"
    response <- httpLBS $ addRequestHeader "Authorization" ("Bearer " <> (pack qiita_access_token)) request
    let posts = case (decode (getResponseBody response) :: Maybe [QiitaPost]) of
                    Just ps -> ps
                    Nothing -> error "unexpected error"
        post_contexts = mapM genQiitaCardItem posts
    return $ listField "qiita_posts" defaultContext post_contexts

genQiitaCardItem post = makeItem "" >>= loadAndApplyTemplate "templates/qiita_card.html" (qiitaCtx post)

qiitaCtx :: QiitaPost -> Context String
qiitaCtx post = constField "title" (post_title post)
                <> constField "url" (post_url post)
                <> defaultContext

main :: IO ()
main = do
    qiitaCtx <- getQiitaCtx
    hakyllWith config $ do
        match "assets/image/*" $ do
            route   idRoute
            compile copyFileCompiler

        match "assets/css/*" $ do
            route   idRoute
            compile compressCssCompiler

        match "assets/js/*" $ do
            route   idRoute
            compile compressCssCompiler

        match "products/*" $ do
            route   $ setExtension "html"
            compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/product.html" defaultContext
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls

        match "index.html" $ do
            route idRoute
            compile $ do
                products <- loadAll "products/*"
                let productsCtx = listField "products" defaultContext (return products)
                getResourceBody
                    >>= applyAsTemplate (productsCtx <> qiitaCtx)
                    >>= loadAndApplyTemplate "templates/default.html" defaultContext
                    >>= relativizeUrls

        match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------

config = defaultConfiguration { deployCommand = deploy }
    where
        deploy = "cp -r _site/* /srv/blog"
