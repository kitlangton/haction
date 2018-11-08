import * as TYPES from "./action-types";

export const setEventDetails = (newUser, oldUser, cool) => ({
  type: TYPES.SET_EVENT_DETAILS,
  payload: { newUser, oldUser, cool }
});

export const deleteEventDetails = (someThing, oldUser, cool, lol) => ({
  type: TYPES.DELETE_EVENT_DETAILS,
  payload: { someThing, oldUser, cool, lol }
});

export const killEvent = mamaBear => ({
  type: TYPES.KILL_EVENT,
  payload: mamaBear
});
