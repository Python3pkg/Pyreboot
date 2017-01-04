#!python
# distutils: language = c
import os
import time


is_non_admin  = os.geteuid() != 0
GLOBAL_MESSAGE = ''

# checking if user has root privileges.
if is_non_admin:
	GLOBAL_MESSAGE = 'root privileges required'
	print("[pyreboot:INFO] reboot.py must be used with root privileges")


cdef extern from "sys/reboot.h" nogil:

	# Reboot options
	cdef enum:
		RB_AUTOBOOT
		RB_HALT_SYSTEM
		RB_ENABLE_CAD
		RB_DISABLE_CAD
		RB_POWER_OFF
		RB_SW_SUSPEND
		RB_KEXEC

	# reboot function, that receive an integer as argument.
	int reboot (int __howto)



cdef inline signed short is_valid_code(int code, dict dcodes):
	"""
	checking if 'int code' variable is a valid code,
	if is a valid code 'dcodes directionary' should contain that code as a key value
	and function should return 1 otherwise return 0.

	:param code: code to test if is valid
	:param dcodes: dictionary where to find valid codes
	:return: 1 or 0, 1 == True and 0 == False
	"""
	if code in dcodes.keys():
		return 1
	return 0


cdef inline str code_as_str(int code, dict dcodes, str default):
	"""
	shall return the code string version, if not exists,
	default will be returned.

	:param code: code to find
	:param dcodes: dictironary where to find code string version
	:param default: default value.
	:return: code string version.
	"""
	try:
		return dcodes[code]
	except:
		return default


class DummyRebooter(object):
	"""
	DummyRebooter is a base class, can be instantiated and can be subclassed
	to add a different beheavior.

	:param code: this is the reboot code and all rebooter should have one.
	"""

	__name__ = 'DummyRebooter'

	class RebootCodes(object):
		"""this class only contains reboot codes."""

		autoboot = RB_AUTOBOOT
		halt_system = RB_HALT_SYSTEM
		enable_cad = RB_ENABLE_CAD
		desable_cad = RB_DISABLE_CAD
		power_off = RB_POWER_OFF
		suspend = RB_SW_SUSPEND
		kexec = RB_KEXEC

		_rcodes = {
			autoboot: '<AUTOBOOT>',
			halt_system: '<HALT SYSTEM>',
			desable_cad: '<DESABLE CAD>',
			enable_cad: '<ENABLE CAD>',
			power_off : '<POWER OFF>',
			suspend: '<SUSPEND>',
			kexec: '<KEXEC>'
		}

		@classmethod
		def is_valid(cls, int code):
			return is_valid_code(code, cls._rcodes) == 1

		@classmethod
		def as_str(cls, int code, str d='<UNKNOW>'):
			return code_as_str(code, cls._rcodes, d)


	def __init__(self, int code):
		self._code = code
		self.failed = None
		self.executed = False

	def __str__(self):
		return '%s(code: %s)' % (self.__name__, self.RebootCodes.as_str(self._code))

	def __repr__(self):
		return self.__str__()

	def reset(self):
		"""
		should reset the rebooter, that way
		the rebooter can be executed again.

		if rebooter is not executed, cannot reset and
		shall raise a RuntimeError.
		"""
		if self.executed:
			self.executed = False
			self.failed = None
		else:
			raise RuntimeError('Rebooter already reseted.')

	def run(self):
		"""
		DummyRebooter shall always return True as a default value.
		you should override this method if you want to add a different
		beheavior.

		:return: True
		"""
		return True

	def _reboot(self):
		"""
		this method shall execute 'reboot' function
		and test if it fails.
		"""
		c = reboot(self._code)
		if c == -1:
			self.failed = True
		else:
			self.failed = None

	def start(self):
		"""
		this method shall execute the rebooter, if is already executed,
		shall raise an error.

		you should never override this method.
		"""
		if self.executed:
			raise RuntimeError('Rebooter already executed.')

		if self.RebootCodes.is_valid(self._code):
			if self.run():
				self._reboot()
		else:
			self.failed = True

		self.executed = True



class TrollRebooterMixin(object):

	"""
	TrollRebooterMixin class mixin, only contains
	a troll title and a troll message.

	you could change this messages too.
	"""

	msg = 'You are hacked!! =) (powering off your computer) '
	title ='HACKED!!'



class ForceRebooterMixin(object):
	"""
	ForceRebooterMixin class mixin, only
	have the option to execute the rebooter
	even if user does not have root privileges,
	but, shall not do anything.

	this is usefull with user interfaces, to show
	a message to the user.
	"""

	def __init__(self, force=False):
		self.force_execute = force


try:
	# if you want to use Gtk dialog or windows
	# you should install gi, by default gi is installed
	# under ubuntu, but i do not know if centos or debian has it as well.
	import gi; gi.require_version('Gtk', '3.0')
	from gi.repository import Gtk

	class GtkDialogRebooter(ForceRebooterMixin, DummyRebooter):
		"""
		shall show a Gtk dialog asking for permission to reboot, power off, others..

		:param code: reboot code
		:param msg: message that will be desplayed on the dialog
		:param force: this options make the rebooter shows the dialog with or without reboot
		"""

		__name__ = 'GtkDialogRebooter'


		def __init__(self, int code, str msg, **kw):
			DummyRebooter.__init__(self, code)
			ForceRebooterMixin.__init__(self, force=kw.get('force', False))
			self._msg = msg
			self._response = None

			if is_non_admin and not self.force_execute:
				self._msg = ' Error ( ' + GLOBAL_MESSAGE + ' )'

		def _dialog_response(self, dialog, response):
			"""
			should be called when click event accounts
			on message dialog and dialog should be destroyed after that event.

			:param dialog: dialog showed
			:param response: click event
			"""
			self._response = response
			dialog.destroy()
			Gtk.main_quit()

		def run(self):
			"""
			Should show a gtk dialog and wait for user response,
			if user click on 'Ok' button, 'rebooter' shall be executed.
			"""
			dialog = Gtk.MessageDialog(parent=None, flags=Gtk.DialogFlags.MODAL,
									   type=Gtk.MessageType.WARNING,
									   buttons=Gtk.ButtonsType.OK, message_format=self._msg)
			dialog.show()

			# dialog shall be connected to '_dialog_response' method
			dialog.connect('response', self._dialog_response)
			Gtk.main()

			# if response if ok, then
			# 'rebooter' shall be executed.
			if self._response == Gtk.ResponseType.OK:
				time.sleep(5)
				return True

			self.failed = True
			return False



	class GtkTrollPowerOff(TrollRebooterMixin, GtkDialogRebooter):
		"""GtkTrollDialog used to have fun with your friends."""

		__name__ = 'GtkTrollPowerOff'

		def __init__(self):
			GtkDialogRebooter.__init__(self, -1, self.msg, force=True)


except ImportError:
	"""
		'gi' should be installed,
		otherwise this error shall be raised.
	"""


try:
	# if you want to use NotifyRebooter,
	# you should install pynoti, you can
	# get it from this url:
	# https://github.com/leoxnidas/pynoti
	from pynoti import noti


	class NotifyRebooter(ForceRebooterMixin, DummyRebooter):
		"""
		NotifyRebooter class, show a message dbus message, only tested on
		ubuntu.

		:code: rebooter code
		:title: message title that shall be displayed on the desktop notification
		:msg: message that shall be displayed on the desktop notification
		:iconPath: icon path that shall be displayed on the desktop notification
		:noCode: notification code, could be LOW, NORMAL, CRITICAL, default LOW.
		:force: this options make the rebooter shows the dialog with or without reboot
		"""

		__name__ = 'NotifyRebooter'

		class NotificationCodes(object):
			LOW = noti.LOW
			NORMAL = noti.NORMAL
			CRITICAL = noti.CRITICAL

			_rcodes = {
				LOW: noti.code_as_str(LOW),
				NORMAL: noti.code_as_str(NORMAL),
				CRITICAL: noti.code_as_str(CRITICAL)
			}

			@classmethod
			def is_valid(cls, int code):
				return is_valid_code(code, cls._rcodes) == 1

			@classmethod
			def as_str(cls, int code, str d=''):
				return code_as_str(code, cls._rcodes, d)


		def __init__(self, int code, str title, str msg, str iconPath=None, int noCode=NotificationCodes.LOW, **kw):
			DummyRebooter.__init__(self, code)
			ForceRebooterMixin.__init__(self, force=kw.get('force', False))
			self._msg = msg
			self._title = title
			self._iconp = iconPath
			self._notiCode = noCode

			if is_non_admin and self.force_execute is None:
				self._title = 'Error'
				self._msg = GLOBAL_MESSAGE

		def __str__(self):
			return DummyRebooter.__str__(self).replace(')', ', notification_level: %s)' % self.NotificationCodes.as_str(self._notiCode))

		def run(self):
			"""
			this method will try to show a notification to the user,
			if something goes wrong, rebooter won't be executed.
			"""
			try:
				notifyer = noti.Noti(self._title, self._msg, iconpath=self._iconp, ulevel=self._notiCode)
				notifyer.run()
				time.sleep(notifyer._expiration_time + 10)
				return True
			except:
				pass

			self.failed = True
			return False


	class TrollNotityRebooter(TrollRebooterMixin, NotifyRebooter):
		"""TrollNotityRebooter used to have fun with your friends."""

		__name__ = 'TrollNotityRebooter'

		def __init__(self):
			NotifyRebooter.__init__(self, -1, self.title, self.msg, force=True)

except ImportError:
	"""
		'pynoti' should be installed first,
		otherwise this error shall be raised.
	"""
