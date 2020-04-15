/*
* @Author: Noah Huetter
* @Date:   2020-04-14 13:49:21
* @Last Modified by:   Noah Huetter
* @Last Modified time: 2020-04-15 08:43:24
*/

#include "hostinterface.h"

#include "version.h"
#include "microphone.h"

/**
 * Simple host-microcontroller interface. Commands are issued from the host with 
 * a single-byte command followed by a variable number of arguments. If the command
 * byte is recognized and the correct number of arguments are passed, a return
 * command RET_CMD_OK is sent, else the corresponding error code.
 */

/*------------------------------------------------------------------------------
 * Types
 * ---------------------------------------------------------------------------*/
typedef enum 
{
  CMD_VERSION = '0',
  CMD_MIC_SAMPLE_PREPROCESSED_MANUAL = '1',
  CMD_MIC_SAMPLE = 0x0,
  CMD_MIC_SAMPLE_PREPROCESSED = 0x1,
} hostCommandIDs_t;

typedef struct 
{
  hostCommandIDs_t cmd;
  uint8_t argCount; // argument in number of bytes
} hostCommands_t;

typedef enum
{
  RET_CMD_OK = 0,
  RET_CMD_NOT_FOUND = 1,
  RET_CMD_TOO_FEW_ARGUMENTS = 2,
} returnCommands_t;

/*------------------------------------------------------------------------------
 * Settings
 * ---------------------------------------------------------------------------*/
/**
 * time to wait for command arguments to arrive before exiting
 */
#define ARGUMENT_LISTEN_DELAY 100

/*------------------------------------------------------------------------------
 * Private data
 * ---------------------------------------------------------------------------*/

static const hostCommands_t commands [] = {
  {CMD_VERSION, 0},
  {CMD_MIC_SAMPLE, 2},
  {CMD_MIC_SAMPLE_PREPROCESSED, 2},
  {CMD_MIC_SAMPLE_PREPROCESSED_MANUAL, 0}
};

/*------------------------------------------------------------------------------
 * Prototypes
 * ---------------------------------------------------------------------------*/
static void runCommand(const hostCommands_t* cmd, uint8_t* args);

/*------------------------------------------------------------------------------
 * Publics
 * ---------------------------------------------------------------------------*/
/**
 * @brief Runs a single interation of the host interface
 * @details 
 */
void hifRun(void)
{
  uint8_t rxData[16];
  hostCommandIDs_t cmdId;
  uint8_t ret;
  const hostCommands_t *cmd;

  // wait for 1 data bytes to arrive
  HAL_UART_Receive(&huart1, &cmdId, 1, HAL_MAX_DELAY);

  // get number of arguments to expect
  cmd = NULL;
  for (int i = 0; i < sizeof(commands)/sizeof(hostCommands_t); i++)
    if(commands[i].cmd == cmdId) cmd = &commands[i];
  // command not found, exit
  if(!cmd)
  {
    ret = RET_CMD_NOT_FOUND;
    HAL_UART_Transmit(&huart1, &ret, 1, HAL_MAX_DELAY);
    return;
  }

  // fetch argument bytes
  if(cmd->argCount>0)
  {
    if (HAL_UART_Receive(&huart1, rxData, cmd->argCount, ARGUMENT_LISTEN_DELAY) != HAL_OK)
    {
      // receive error
      ret = RET_CMD_TOO_FEW_ARGUMENTS;
      HAL_UART_Transmit(&huart1, &ret, 1, HAL_MAX_DELAY);
      return;
    }
  }

  // command accepted
  ret = RET_CMD_OK;
  HAL_UART_Transmit(&huart1, &ret, 1, HAL_MAX_DELAY);

  // execute command
  runCommand(cmd, rxData);
}

/*------------------------------------------------------------------------------
 * Privates
 * ---------------------------------------------------------------------------*/
/**
 * @brief executes a given command
 * @details 
 * 
 * @param cmd pointer to command
 * @param args pointer to command arguments
 */
static void runCommand(const hostCommands_t* cmd, uint8_t* args)
{
  uint16_t u16;
  uint8_t u8;

  switch(cmd->cmd)
  {
    case CMD_VERSION:
      printf("%s / %s / %s / %s\n", verProgName, verVersion, verBuildDate, verGitSha);
      break;
    case CMD_MIC_SAMPLE:
      // parse arguments
      u16 = args[0]<<8 | args[1];
      // call
      micHostSampleRequest(u16);
      break;
    case CMD_MIC_SAMPLE_PREPROCESSED:
      // parse arguments
      u16 = args[0]<<8 | args[1];
      // call
      micHostSampleRequestPreprocessed(u16);
    case CMD_MIC_SAMPLE_PREPROCESSED_MANUAL:
      micHostSampleRequestPreprocessed(10000);
    default:
      // invalid command
      return;
  }
}

/*------------------------------------------------------------------------------
 * Callbacks
 * ---------------------------------------------------------------------------*/
