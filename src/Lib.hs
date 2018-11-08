module Lib
  ( run
  )
where

import           Prelude                 hiding ( (<>) )
import           Text.Casing
import           Text.PrettyPrint

data Action = Action {
  name :: String,
  arguments :: [String]
}

run = do
  actions <- parseActions <$> readFile "./actions.txt"
  writeFile "./action-types.js"    (render $ printActionTypes actions)
  writeFile "./action-creators.js" (render $ printActionCreators actions)

test actions =
  printActionTypes actions $$ "----" $$ printActionCreators actions

parseAction :: String -> Action
parseAction (words -> (name:args)) = Action name args

parseActions :: String -> [Action]
parseActions = fmap parseAction . lines

actions =
  [ Action "set event details" ["post details", "b", "c"]
  , Action "deleteUser"        ["userName"]
  , Action "addUser"           ["userId"]
  ]


printActionCreators actions =
  "import * as TYPES from './action-types'" $$ "" $$ vcat
    (fmap printActionCreator actions)

printActionTypes :: [Action] -> Doc
printActionTypes = vcat . fmap printActionType

printActionType :: Action -> Doc
printActionType (Action (fromAny -> name) _) =
  "export const" <+> ssAction <+> "=" <+> doubleQuotes ssAction
  where ssAction = text $ toScreamingSnake name

printActionCreator :: Action -> Doc
printActionCreator (Action (fromAny -> name) (fmap (toCamel . fromAny) -> args))
  = "export const"
    <+> text (toCamel name)
    <+> "="
    <+> argsDoc
    <+> "=> ({"
    $$  nest 2 object
    $$  "})"
 where
  argsDoc = parens . hsep $ punctuate "," (text <$> args)
  payloadDoc | length args == 1 = text $ head args
             | otherwise        = braces . hsep $ punctuate "," (text <$> args)
  object =
    "type:"
      <+> "TYPES."
      <>  (text $ toScreamingSnake name)
      <>  ","
      $$  "payload:"
      <+> payloadDoc
